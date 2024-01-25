package main

import (
    "bytes"
    "encoding/json"
    "io/ioutil"
    "net/http"
    "os"
    "path/filepath"
    "strings"
    "fmt"
)

// Email struct represents the structure of an email
type Email struct {
    Sender    string `json:"sender"`
    Recipient string `json:"recipient"`
    Date      string `json:"date"`
    Subject   string `json:"subject"`
    Body      string `json:"body"`
}

func main() {
    // Directory containing the extracted emails
    emailDir := "../../../datasets/enron_mail_20110402/maildir" 

    filepath.Walk(emailDir, func(path string, info os.FileInfo, err error) error {
        if err != nil {
            fmt.Printf("Error accessing path %q: %v\n", path, err)
            return err
        }

        if info.IsDir() && filepath.Base(path) == "all_documents" {
            // Process all files within this 'all_documents' directory
            emails := processAllDocumentsFolder(path)
            bulkIndexEmails(emails) // Bulk index the accumulated emails
        }
        return nil
    })

}

func processAllDocumentsFolder(folderPath string) []Email {
    var emails []Email
    filepath.Walk(folderPath, func(path string, info os.FileInfo, err error) error {
        if err != nil {
            fmt.Println("Error accessing file:", err)
            return err
        }

        if !info.IsDir() {
            email := processEmailFile(path) // Assuming this function returns an Email object
            emails = append(emails, email)
        }
        return nil
    })
    return emails
}

func processEmailFile(filePath string) Email {
    // Open the file
    file, err := os.Open(filePath)
    if err != nil {
        fmt.Printf("Error opening file %s: %v\n", filePath, err)
        return Email{} // Return an empty Email object in case of an error
    }
    defer file.Close()

    // Read the file
    data, err := ioutil.ReadAll(file)
    if err != nil {
        fmt.Printf("Error reading file %s: %v\n", filePath, err)
        return Email{} // Return an empty Email object in case of an error
    }

    // Parse the email data
    return parseEmail(data)
}

func parseEmail(data []byte) Email {
    lines := strings.Split(string(data), "\n")
    email := Email{}

    headersParsed := false
    bodyLines := []string{}

    for _, line := range lines {
        if line == "" && !headersParsed {
            headersParsed = true
            continue
        }

        if !headersParsed {
            // Parse headers here. This is simplified; real parsing is more complex.
            if strings.HasPrefix(line, "Date: ") {
                email.Date = strings.TrimPrefix(line, "Date: ")
            } else if strings.HasPrefix(line, "From: ") {
                email.Sender = strings.TrimPrefix(line, "From: ")
            } else if strings.HasPrefix(line, "To: ") {
                email.Recipient = strings.TrimPrefix(line, "To: ")
            } else if strings.HasPrefix(line, "Subject: ") {
                email.Subject = strings.TrimPrefix(line, "Subject: ")
            }
            // Add more headers as needed
        } else {
            bodyLines = append(bodyLines, line)
        }
    }

    email.Body = strings.Join(bodyLines, "\n")
    return email
}

func bulkIndexEmails(emails []Email) {
    if len(emails) == 0 {
        return // Nothing to index
    }

    var bulkRequestBody bytes.Buffer
    for _, email := range emails {
        meta := map[string]interface{}{
            "index": map[string]interface{}{
                "_index": "enron_emails", // Replace with your index name
            },
        }
        metaJSON, _ := json.Marshal(meta)
        bulkRequestBody.Write(metaJSON)
        bulkRequestBody.Write([]byte("\n"))

        emailJSON, _ := json.Marshal(email)
        bulkRequestBody.Write(emailJSON)
        bulkRequestBody.Write([]byte("\n"))
    }

    // Bulk API endpoint
    bulkEndpoint := "http://localhost:4080/api/_bulk"

    req, err := http.NewRequest("POST", bulkEndpoint, &bulkRequestBody)
    if err != nil {
        fmt.Println("Error creating bulk request:", err)
        return
    }
    req.Header.Set("Content-Type", "application/x-ndjson")
    req.SetBasicAuth("admin", "complexpassword") // Set your credentials

    client := &http.Client{}
    resp, err := client.Do(req)
    if err != nil {
        fmt.Println("Error sending bulk request to ZincSearch:", err)
        return
    }
    defer resp.Body.Close()

    // Handle the response...
    responseBody, err := ioutil.ReadAll(resp.Body)
    if err != nil {
        fmt.Println("Error reading bulk response body:", err)
        return
    }

    fmt.Printf("Bulk response from ZincSearch: %s\n", string(responseBody))
}



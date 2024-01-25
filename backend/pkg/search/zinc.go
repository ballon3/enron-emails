package search

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"strings"
)

type Email struct {
	Sender    string `json:"sender"`
	Recipient string `json:"recipient"`
	Subject   string `json:"subject"`
	Body      string `json:"body"`
	Date      string `json:"date"`
}

func PerformSearch(query string) ([]Email, error) {
	// Construct the search query for ZincSearch
	// Adjust the JSON structure as per your ZincSearch setup and requirements
	inputQuery := fmt.Sprintf(`{
        "query": {
            "bool": {
                "must": [
                    {
                        "range": {
                            "@timestamp": {
                                "gte": "2024-01-18T08:19:41.112Z",
                                "lt": "2024-01-25T08:19:41.112Z",
                                "format": "2006-01-02T15:04:05Z07:00"
                            }
                        }
                    },
                    {
                        "query_string": {
                            "query": "%s"
                        }
                    }
                ]
            }
        },
        "sort": [
            "-@timestamp"
        ],
        "from": 0,
        "size": 5,
        "aggs": {
            "histogram": {
                "date_histogram": {
                    "field": "@timestamp",
                    "calendar_interval": "1d",
                    "fixed_interval": ""
                }
            }
        }
    }`, query)

	// Adjust the ZincSearch endpoint URL
	zincEndpoint := "http://localhost:4080/es/enron_emails/_search"

	// fmt.Println("Sending request to ZincSearch:", inputQuery)

	// Create and send the request
	req, err := http.NewRequest("POST", zincEndpoint, strings.NewReader(inputQuery))
	if err != nil {
		return nil, err
	}
	req.Header.Set("Content-Type", "application/json")
	req.SetBasicAuth("admin", "complexpassword") // Replace with actual credentials

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	// Read and parse the response
	responseBody, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	var result struct {
		Hits struct {
			Hits []struct {
				Source Email `json:"_source"`
			} `json:"hits"`
		} `json:"hits"`
	}

	if err := json.Unmarshal(responseBody, &result); err != nil {
		return nil, err
	}

	// Extract emails from the response
	var emails []Email
	for _, hit := range result.Hits.Hits {
		emails = append(emails, hit.Source)
	}

	return emails, nil
}

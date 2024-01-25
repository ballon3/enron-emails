<template>
  <div class="container mx-auto p-4">
    <div class="container mx-auto p-4">
      <h1 class="text-4xl font-bold mb-8">ENRON 📧's</h1>
    </div>
    <div class="mb-4">
      <input
        type="text"
        v-model="searchQuery"
        @keyup.enter="searchEmails"
        class="border p-2 rounded w-80"
        placeholder="Search emails..."
      >
      <button @click="searchEmails" class="bg-gray-500 hover:bg-gray-700 text-white font-bold py-2 px-4 rounded">
        Search
      </button>
    </div>
    <div>
      <table class="table-auto w-full">
        <thead>
          <tr>
            <th class="border px-4 py-2">Sender</th>
            <th class="border px-4 py-2">Subject</th>
            <th class="border px-4 py-2">Recipient</th>
            <th class="border px-4 py-2">Body</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(email) in emails" :key="email.id">
            <td class="border w-4 px-4 py-2">{{ email.sender }}</td>
            <td class="border w-4 px-4 py-2">{{ email.subject }}</td>
            <td class="border w-4 px-4 py-2">{{ email.recipient }}</td>
            <td class="border px-4 py-2">
              <div class="email-body">
                {{ email.body }}
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      searchQuery: '',
      emails: [],
      visibleBodies: {} // Keep track of which email bodies are visible
    };
  },
  methods: {
    async searchEmails() {
      const response = await fetch(`http://localhost:8080/search?search=${this.searchQuery}`);
      if (response.ok) {
        const data = await response.json();
        console.log(data);
        this.emails = data;

      } else {
        console.error('Error fetching data:', response.statusText);
        // Handle errors appropriately in a real application
      }
    },
    toggleBody(index) {
      this.$set(this.visibleBodies, index, !this.visibleBodies[index]);
    }
  }
};
</script>

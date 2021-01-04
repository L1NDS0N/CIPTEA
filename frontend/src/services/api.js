import axios from 'axios';
require('dotenv').config()

const api = axios.create({
    baseURL: 'https://3333-b90ff000-4b6c-4aab-80e8-00aea86fe36b.ws-us03.gitpod.io',

});
        console.log(process.env.API_URL)

export default api;
const express = require('express');
const cors = require('cors');
const eventRoutes = require('./routes/eventRoutes');
const registrationRoutes = require('./routes/registrationRoutes');

const app = express();

//Middleware indispensables
app.use(cors());//pour permettre a flutter de communiquer avec l'API
app.use(express.json());//pour parser les requetes POST

//definition des routes avec le prefixe /api
app.use('/api/events',eventRoutes);
app.use('/api/registrations',registrationRoutes);

const PORT = 3000;
app.listen(PORT,()=>{
    console.log(`Serveur demarre sur http://localhost:${PORT}`);

});
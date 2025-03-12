const https = require('https');
const querystring = require('querystring');
const fs = require('fs'); // Importez le module 'fs'

// Récupération des variables d'environnement
const hostname = process.env.SEEDBOX_HOST_NAME;
const username = process.env.TOOLS_PSB_NAME;
const password = process.env.TOOLS_PSB_PASSWORD;
// Configuration (à adapter à votre NAS)
const nasHost = '192-168-1-50.ds218plus-lebideau.direct.quickconnect.to'; // Remplacez par l'adresse IP ou le nom d'hôte de votre NAS
const nasPort = 5001; // Port HTTPS par défaut

const downloadUrl = 'https://psb27728.seedbox.io/files/L.Amour.ouf.2024.FRENCH.1080p.WEB.H265-TyHD.mkv'; // Remplacez par l'URL du torrent, magnet, etc.

const certPath = './cert.pem'; // Chemin vers votre certificat

async function authenticate() {
    return new Promise((resolve, reject) => {
        const authData = querystring.stringify({
            api: 'SYNO.API.Auth',
            version: 7, // Essayez aussi 3 si 7 ne fonctionne pas
            method: 'login',
            account: username,
            passwd: password,
            session: 'DownloadStation',
            format: 'cookie'
        });

        const options = {
            hostname: nasHost,
            port: nasPort,
            path: '/webapi/auth.cgi?' + authData,
            method: 'GET',
            ca: fs.readFileSync(certPath) // Spécifiez le certificat
        };

        const req = https.request(options, (res) => {
            let data = '';

            res.on('data', (chunk) => {
                data += chunk;
            });

            res.on('end', () => {
                try {
                    const response = JSON.parse(data);

                    if (response.success) {
                        const sid = response.data.sid;
                        console.log('Authentification réussie! SID:', sid);
                        resolve(sid); // Résoudre avec le SID
                    } else {
                        console.error('Erreur d\'authentification:', response.error);
                        reject(response.error); // Rejeter avec l'erreur
                    }
                } catch (error) {
                    console.error('Erreur lors de l\'analyse de la réponse JSON:', error);
                    reject(error);
                }
            });
        });

        req.on('error', (error) => {
            console.error('Erreur lors de la requête:', error);
            reject(error);
        });

        req.end();
    });
}

// Exemple d'utilisation (exécution de l'authentification)
authenticate()
    .then(sid => {
        console.log('SID récupéré avec succès:', sid);
        // Ici, vous pouvez appeler d'autres fonctions qui utilisent le SID
    })
    .catch(error => {
        console.error('L\'authentification a échoué:', error);
    });
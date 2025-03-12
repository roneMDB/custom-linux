#!/usr/bin/env node

const https = require('https');
const cheerio = require('cheerio');

// Récupération des variables d'environnement
const login = process.env.TOOLS_PSB_NAME;
const password = process.env.TOOLS_PSB_PASSWORD;
const hostname = process.env.SEEDBOX_HOST_NAME;
const baseUrl = 'https://' + hostname;
const filesUrl = baseUrl + '/files/';

// Affiche l'aide
function showHelp() {
  console.log(`
Usage: node scraper.js [options] [search_term]

Options:
  --exclude-nfo  Exclut les fichiers avec l'extension ".nfo" des résultats.
  --help         Affiche cette aide.

Arguments:
  search_term    Terme de recherche optionnel pour filtrer les résultats (insensible à la casse).
`);
  process.exit(0);
}

// Fonction pour lister les fichiers dans un répertoire
async function listFiles(url, searchTerm, excludeNfo, options) {
  return new Promise((resolve, reject) => {
    https.get(url, options, (res) => {
      let data = '';

      res.on('data', (chunk) => {
        data += chunk;
      });

      res.on('end', () => {
        const $ = cheerio.load(data);
        const files = [];

        $('a').each((index, element) => {
          let href = $(element).attr('href');
          if (href && href !== '../') {
            const fullUrl = new URL(href, url).href;
            const decodedUrl = decodeURIComponent(fullUrl);

            // Filtrer si un terme de recherche est fourni (insensible à la casse)
            const searchTermCondition = !searchTerm || decodedUrl.toLowerCase().includes(searchTerm.toLowerCase());

            // Filtrer si l'extension .nfo doit être exclue
            const excludeNfoCondition = !excludeNfo || !fullUrl.toLowerCase().endsWith('.nfo');


            if (searchTermCondition && excludeNfoCondition) {
              files.push(fullUrl); // Pousser l'URL originale (non décodée)
            }
          }
        });
        resolve(files);
      });
    }).on('error', (err) => {
      reject(err);
    });
  });
}

async function main() {
  try {
    const options = {
      auth: `${login}:${password}`
    };

    // Récupérer les arguments de la ligne de commande
    let searchTerm = null;
    let excludeNfo = false;

    for (let i = 2; i < process.argv.length; i++) {
      const arg = process.argv[i];
      if (arg === '--exclude-nfo') {
        excludeNfo = true;
      } else if (arg === '--help') {
        showHelp();
      } else if (!searchTerm) {
        searchTerm = arg;
      }
    }


    // Récupérer la liste des fichiers et répertoires à la racine
    const initialFiles = await listFiles(filesUrl, searchTerm, excludeNfo, options);
    // console.log('Liste des fichiers à la racine :');
    console.log(initialFiles.filter(file => !file.endsWith('/')).join('\n'));

    // Filtrer les répertoires (ceux qui se terminent par '/')
    const directories = initialFiles.filter(file => file.endsWith('/'));

    // Pour chaque répertoire, récupérer la liste des fichiers qu'il contient
    for (const directory of directories) {
      const directoryUrl = new URL(directory, filesUrl).href;
      try {
        const filesInDirectory = await listFiles(directoryUrl, searchTerm, excludeNfo, options);
        // console.log(`\nFichiers dans le répertoire ${directoryUrl}:`);
        console.log(filesInDirectory.join('\n'));
      } catch (error) {
        console.error(`Erreur lors de la récupération des fichiers dans ${directoryUrl}: ${error.message}`);
      }
    }
  } catch (error) {
    console.error(`Erreur générale : ${error.message}`);
  }
}

main();

/**
 * Fetches the latest aggregated health and checkin data, writing a CSV file.
 *
 * @ Aaron Baw 2019
 */

const fs = require('fs');
const request = require('request');
const _SAMPLE_LOCAL_DATA = JSON.parse(fs.readFileSync('./sampleAggHealthAndCheckinData.json').toString('utf8'));

function getHealthData(){ return new Promise((resolve, reject) => {
    request.get(`http://benson-backend.herokuapp.com/api/v1/healthDataAndCheckinsAggregatedBy/${process.argv[2]}`, (req, res) => {
      return resolve(JSON.parse(res.body));
    });
  })
};

async function main(healthData){

  if (!healthData) healthData = await getHealthData();

  // let keys = new Set(Object.keys(healthData.result[0]));

  // Find the result with the largest set of keys.
  let keys = new Set(healthData.result.map(Object.keys).sort((a, b) => b.length - a.length)[0]);

  healthData.result.forEach(result => {

    keys.add(...Object.keys(result));

  });

  // Turn the set of keys into an array so that we can preserve the ordering.
  keys = Array.from(keys).filter(key => key !== 'attributesAndCounts');

  // Start building out the CSV string.
  let csvString = "";
  keys.forEach((key, i) => csvString += key += (i !== keys.length -1 ? "," : ""));

  log(`CSV Header:`, csvString);

  healthData.result.forEach(result => {

    csvString += `\n`

    keys.forEach((key, i) => {

      csvString += (result[key] ? result[key] : "") + (i !== keys.length - 1 ? "," : "")

    });

  });

  fs.writeFileSync('sample_agg_health_and_checkin_data.csv', csvString, 'utf8');

  log(`Generated CSV:`, csvString);

}

main().catch(console.error);


function log(...msg){
  console.log(`CONVERT TO CSV |`, ...msg);
}

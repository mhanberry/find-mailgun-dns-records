const fs = require('fs')
const util = require('util')

const readFile = (fileName) => util.promisify(fs.readFile)(fileName, 'utf-8')

// Search the files for record sets related to mailgun
function filterMailgunRecordSets(resourceRecordSet){
	let matchingRecords = resourceRecordSet.ResourceRecords?.filter(record => record.Value.match('mailgun') !== null)
	return matchingRecords != undefined && matchingRecords.length > 0
}

async function main(data){
	let files = data.toString().trim().split('\n')

	// Print the mailgun-related record names from each file
	for(file of files){
		let hostedZones = JSON.parse(await readFile(file))
		let mailgunRecordSets = hostedZones.ResourceRecordSets.filter(filterMailgunRecordSets)
		let recordNames = mailgunRecordSets.map(recordSet => recordSet.Name)

		console.log(file)
		recordNames.forEach(name => console.log(`\t${name}`))
		console.log()
	}
}

// Accept a list of json files from stdin
process.stdin.on('data', main)

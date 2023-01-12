const randomBytes = require('crypto').randomBytes;

const AWS = require('aws-sdk');

const ddb = new AWS.DynamoDB.DocumentClient();

exports.handler = (event, context, callback) => {
    const requestBody = JSON.parse(event.body);

    let reading = {
        ReadingId: toUrlString(randomBytes(16)),
        date: new Date().toISOString(),
        sensorId: requestBody.SensorId,
        temperature: requestBody.temperature,
        pressure: requestBody.pressure,
        humidity: requestBody.humidity,
    };

    saveReading(reading).then(() => {
        callback(null, {
            statusCode: 201,
            body: JSON.stringify({
                //
            }),
            headers: {
                'Access-Control-Allow-Origin': '*',
            },
        });
    }).catch((err) => {
        console.error(err);

        errorResponse(err.message, context.awsRequestId, callback)
    });
};

function saveReading(reading) {
    return ddb.put({
        TableName: 'Bme280v2',
        Item: reading,
    }).promise();
}

function errorResponse(errorMessage, awsRequestId, callback) {
  callback(null, {
    statusCode: 500,
    body: JSON.stringify({
      Error: errorMessage,
      Reference: awsRequestId,
    }),
    headers: {
      'Access-Control-Allow-Origin': '*',
    },
  });
}

function toUrlString(buffer) {
    return buffer.toString('base64')
        .replace(/\+/g, '-')
        .replace(/\//g, '_')
        .replace(/=/g, '');
}
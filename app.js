const express = require('express');
const fs = require('fs');
const osmPbfParser = require('osmpbf');

const app = express();
const filePath = 'your.osm.pbf';  // OSM 파일 경로

app.get('/osm', (req, res) => {
  const stream = fs.createReadStream(filePath);
  const parser = new osmPbfParser();

  stream.pipe(parser);

  let nodes = [];

  parser.on('data', (item) => {
    if (item.type === 'node') {
      nodes.push(item);
    }
  });

  parser.on('end', () => {
    res.json(nodes);  // 노드 데이터를 JSON으로 반환
  });
});

app.listen(3000, () => {
  console.log('Server running on port 3000');
});

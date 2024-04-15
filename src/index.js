import express from "express"

const app = express()

const SERVICE = process.env.SERVICE_NAME;
const PORT = process.env.PORT;

app.get("/", (req, res) => {
  res.send(`service: ${SERVICE}`);
});

app.listen(PORT, () => {
  console.log(`app is listening at http://localhost:/${PORT}`)
})




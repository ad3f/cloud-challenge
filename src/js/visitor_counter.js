const counter = document.getElementById("visit_count");
const url =
  "https://go42ln7xp0.execute-api.ap-southeast-2.amazonaws.com/serverless_lambda_prod/api/visitors";
let xhr = new XMLHttpRequest();

//begin fetching our visitor count using our API
fetch(url)
  .then((res) => {
    return res.json();
  })
  .then((data) => {
    counter.textContent = data;
  });

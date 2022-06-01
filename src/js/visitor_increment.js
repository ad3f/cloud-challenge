const uri =
  "https://go42ln7xp0.execute-api.ap-southeast-2.amazonaws.com/serverless_lambda_prod/api/visitors";
let xhr = new XMLHttpRequest();

//begin fetching our visitor count using our API

$(document).ready(function () {
  $.ajax({
    type: "POST",
    url: uri,
  });
});

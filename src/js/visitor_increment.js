const address =
  "https://go42ln7xp0.execute-api.ap-southeast-2.amazonaws.com/serverless_lambda_prod/api/visitors";

window.addEventListener("load", function () {
  //everything is fully loaded, don't use me if you can use DOMContentLoaded
  var xhr = new XMLHttpRequest();
  xhr.open("PUT", address);

  xhr.setRequestHeader("Content-Type", "application/json");

  xhr.onreadystatechange = function () {
    if (xhr.readyState === 4) {
      console.log(xhr.status);
      console.log(xhr.responseText);
    }
  };

  xhr.send();
});

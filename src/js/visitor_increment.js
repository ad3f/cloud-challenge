const url_add =
  "https://go42ln7xp0.execute-api.ap-southeast-2.amazonaws.com/serverless_lambda_prod/api/visitors";

window.addEventListener("load", function () {
  let xhr2 = new XMLHttpRequest();
  xhr2.open("PUT", url_add);

  xhr2.setRequestHeader("Content-Type", "application/json");

  xhr2.onreadystatechange = function () {
    if (xhr2.readyState === 4) {
      console.log(xhr2.status);
      console.log(xhr2.responseText);
    }
  };

  xhr2.send();
});

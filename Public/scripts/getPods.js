searchinput.onkeypress = function() {searchInputChanged()};
var pods = [
            {
            name: "swift",
            url: "https://raw.githubusercontent.com/ankit1ank/virtualswift/master/README.md"
            },
            {
            name: "swift whatever",
            url: "https://raw.githubusercontent.com/ankit1ank/virtualswift/master/README.md"
            }
            ]
function searchInputChanged() {
    fetch('https://raw.githubusercontent.com/visionmedia/superagent/master/Readme.md', {mode: 'cors'})
    .then(function(response) {
          return response.text();
          })
    .then(function(myString) {
          pods.push({
                    name: "lol",
                    url: "lolalot"
                    })
          var tableHTML = ""
          for (var i = 0; i < pods.length; i++) {
          var rowNumber = i + 1
          var row = "<tr><th scope=\"row\">" + rowNumber + "</th><td>" + pods[i].name + "</td><td>" + pods[i].url + "</td></tr>"
          tableHTML = tableHTML + row
          }
          results.innerHTML = tableHTML
          });
}

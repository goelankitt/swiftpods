window.onload = function() {renderReadme()};
function renderReadme() {
    fetch('https://raw.githubusercontent.com/visionmedia/superagent/master/Readme.md', {mode: 'cors'})
    .then(function(response) {
          return response.text();
          })
    .then(function(responseText) {
          markdowntest.innerHTML = markdown.toHTML(responseText);
          });
}

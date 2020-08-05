function toggleSearchLoader() {
  var x = document.getElementById("searchLoader");
  if (x.style.display === "none") {
    x.style.display = "block";
  } else {
    x.style.display = "none";
  }
}

function appendSearchResults(searchResults){
  var node = document.createElement("li");                 // Create a <li> node
  var textnode = document.createTextNode(searchResults);         // Create a text node
  node.appendChild(textnode);                              // Append the text to <li>
  document.getElementById("searchResults").appendChild(node);
  toggleSearchLoader();
}

function searchFunction() {
  toggleSearchLoader()
  let searchInput = document.getElementById("searchInput");
  let userId = searchInput.getAttribute("data-userId");
  let searchTerm = searchInput.value

  getSearchMatch(userId, searchTerm)
    .then(data => { appendSearchResults(data) })
    .catch(error => { console.log(error) })
}

async function getSearchMatch(userId, searchTerm) {
  // Default options are marked with *
  const response = await fetch("/find_expert?user_id="+userId+"&search="+searchTerm)
  return response.json(); // parses JSON response into native JavaScript objects
}

document.getElementById('searchSubmit').onclick = searchFunction;
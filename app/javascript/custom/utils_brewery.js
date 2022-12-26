const BREWERIES = {};

const handleResponse = (breweries) => {
  BREWERIES.list = breweries;
  BREWERIES.show();
};

const createTableRow = (brewery) => {
  const tr = document.createElement("tr");
  tr.classList.add("tablerow");
  const breweryname = tr.appendChild(document.createElement("td"));
  breweryname.innerHTML = brewery.name;
  const founded = tr.appendChild(document.createElement("td"));
  founded.innerHTML = brewery.year
  const total = tr.appendChild(document.createElement("td"));
  total.innerHTML = brewery.total.number
  const status = tr.appendChild(document.createElement("td"));
  status.innerHTML = brewery.active
  
  return tr;
};

BREWERIES.show = () => {
  const table = document.getElementById("brewerytable");
  BREWERIES.list.forEach((brewery) => {
    const tr = createTableRow(brewery);
    table.appendChild(tr);
  });
};

const breweries = () => {
  fetch("breweries.json")
    .then((response) => response.json())
    .then(handleResponse);
};

export { breweries };

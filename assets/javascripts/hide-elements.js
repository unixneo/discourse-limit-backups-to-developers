my_el = document.querySelectorAll("td.backup-controls > div")

if (typeof my_el !== 'undefined') {
    my_el.forEach(element => element.parentElement.removeChild(element));
}

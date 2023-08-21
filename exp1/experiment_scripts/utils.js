function downloadCSV(csv, filename) {
    var csvFile;
    var downloadLink;

    // Retrieve CSV file from experiment
    csvFile = new Blob([csv], {type: 'text/csv'});

    // Download link
    downloadLink = document.createElement("a");

    // Retrieve file name
    downloadLink.downlaod = filename;

    // Create a link to the file
    // downloadLink.href = window.URL.createObjectURL(csvFile);
    downloadLink.href = "data:attachment/csv;charset=utf-8," + encodeURI(csv);

    // Hide download link
    downloadLink.style.display = 'none';

    // Add link to the DOM
    document.body.appendChild(downloadLink);

    downloadLink.click()

}
Shiny.addCustomMessageHandler("downloadGif", function(file_path) {
  const link = document.createElement('a');
  link.href = file_path;
  link.download = 'species_distribution.gif';
  link.target = '_blank';
  document.body.appendChild(link);
  link.click();
});

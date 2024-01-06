var serverUrl = "http://localhost:" + port + "/transliterate"; 

function getInputAsJson() {
    return "\"" + $('#input').val() + "\"";
}

function transliterate() {
    $.ajax({
      type:    'POST',
      url:     serverUrl,
      data:    getInputAsJson(),
      headers: {"Content-Type": "application/json"},
      success: function(data){
                    $("#output-deva").html(data[0]);
                    $("#output-iast").html(data[2]);
                    $("#output-hk").html(data[1]);
                    $("#output-iso").html(data[3]);
               },
      error:   function(xhr, textStatus, error){
                    $("#alert").css('opacity', '1.0');
               }
    });

}


$(document).ready(function() {
    new ClipboardJS('.clp');
    transliterate();
});
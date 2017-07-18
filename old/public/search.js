function loadAPIClientInterfaces() {
  gapi.client.load('youtube', 'v3', function() {
    handleAPILoaded();
  });
}

function handleAPILoaded() {
	$('#search-button').attr('disabled', false);
}

function search() {
	var q = $('#query').val();
	var request = gapi.client.youtube.search.list({
		key: 'AIzaSyBCUUOihvICOL8DiSP3gB3DxEGqz3JeALU',
		q: q,
		part: 'snippet'
	});

	request.execute(function(response) {
		var str = JSON.stringify(response.result);
		$('#search-container').html('<pre>' + str + '</pre>');
	});
}
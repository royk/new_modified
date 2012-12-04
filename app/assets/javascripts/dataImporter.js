var IM = (function() {
	return {
		videoImport: function videoImport(input) {
			$.post('/saveVideo', {videos:input});
		}
	};
}());
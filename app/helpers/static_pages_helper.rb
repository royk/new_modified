module StaticPagesHelper
	def my_tinymce()
		get_tinymce_code.html_safe
	end

	def get_tinymce_code
		<<-eos
		   <script>
			tinyMCE.init({
				"mode":"specific_textareas",
				"editor_selector":"tinymce",
				"theme":"advanced",
				"theme_advanced_toolbar_location":"top","theme_advanced_toolbar_align":"left","theme_advanced_statusbar_location":"bottom","theme_advanced_resizing":true,"theme_advanced_buttons3_add":"tablecontrols,fullscreen",
				"plugins":"table,fullscreen",
				"language":"en",
				"init_instance_callback": function() {
					tinyMCE.activeEditor.dom.loadCSS('/assets/custom.css');
					}
				}
			);
			</script>
		eos
	end
end

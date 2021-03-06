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
				skin : "bootstrap",
				"theme_advanced_toolbar_location":"top","theme_advanced_toolbar_align":"left","theme_advanced_statusbar_location":"bottom","theme_advanced_resizing":true,
				"theme_advanced_buttons1_add":"fontselect,fontsizeselect,pdw_toggle",
				"theme_advanced_buttons2_add":"forecolor,backcolor,emotions",
				"theme_advanced_buttons3_add":"tablecontrols,fullscreen",
				"plugins":"pdw,table,fullscreen,emotions",
				"language":"en",
				pdw_toggle_on: 1,
				pdw_toggle_toolbars: "2,3",
				"theme_advanced_disable" : "styleselect",
				"theme_advanced_fonts" : "Arial=arial,helvetica,sans-serif;Arvo=arvo,serif;Courier New=courier new,courier,monospace;Impact=impact, sans-serif;Nobile=nobile, sans-serif;PT Sans=pt sans, sans-serif;Verdana=verdana, sans-serif",
				"body_class": "user_content",
				gecko_spellcheck : true,
				"setup": function(ed) {
						ed.onBeforeSetContent.add(function(ed, cm) {
							tinyMCE.activeEditor.dom.addClass("tinymce","user_content");
							tinyMCE.activeEditor.dom.loadCSS('/assets/custom.css');
						});
				}
			});
			</script>
		eos
	end
end

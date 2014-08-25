// Now load the module
(function(){

    // Init the Lings module here
    this.Terraling = this.Terraling || {};
    this.Terraling.Lings = this.Terraling.Lings || {};

    var lings = this.Terraling.Lings;

    lings.show = {
        init: setupAnalysis
    };
    
    // local variable containing the state of the page
    var currentId,
    currentDepth,
        resourceTemplate,
        resourcesDict;

    var resourceId = 'ling';

    function setupAnalysis(){
        // Set the id
        currentId = $('#details').data('id') || '';
        currentDepth = + $('#details').data('depth') || 0;
        // Setup the resource "cache"
        // we use it to prevent duplicates on the list
        resourcesDict = {};
        // perhaps we should get it from a Handlebar template script
        // var htmlTemplate = '<li data-id="{{id}}"><a class="remove-ling" href="#"><span class="glyphicon glyphicon-remove shift-down"></a> {{name}}</li>';

        // resourceTemplate = Hogan.compile(htmlTemplate);
        var tplPath = T.controller.toLowerCase() + '/' + T.action.toLowerCase();
        resourceTemplate = HoganTemplates[tplPath];

        // bind some buttons here
        // bindAnalysis('#compare-lings', '&search[ling_set][0]=compare');
        // bindAnalysis('#compare-tree' , '&search[advanced_set][clustering]=hamming');
        bindAnalysis('#compare-lings', 'compare');
        bindAnalysis('#similarity-tree', 'clustering');

        // init the typeahead
        setupTypeahead();

        $(document)
          .on('click', '.remove-lings', removeLanguages)
          .on('click', '.remove-ling' , removeLanguage);

        // load Map
        $("#mapButton").one('click', loadMap);
    }

    function checkButtons(criteria){
      var buttons = $('div#compare-buttons a');
      if(criteria){
        buttons.removeAttr('disabled');
      } else {
        buttons.attr('disabled', 'disabled');
      }
    }

    function addLingsToParams(params){
      // iterate on 
      var ids = $.map( $('#selected-lings li'), function (entry, i) {
          return $(entry).data('id');
      });
      // add the current id
      ids.push(currentId);
      
      // add the ids to the relative depth
      params.lings['' + currentDepth] = ids;
    }

    function addSearchTypeToParams(params, type){
      var isClustering = 'clustering' === type;
      if(isClustering){
        params.advanced_set.clustering = 'hammering';
      } else {
        params.ling_set['' + currentDepth] = 'compare';
      }
    }

    function doAnalysis(type){
      var params = buildQueryParams(type);
      return $.post(analysisURL(), params);
    }

    function buildLingsURL(){
        //TODO: refactor this stuff here!
        return '&search[lings][0][]=' + ($.map( $('#selected-lings li'), function (val, i) {
            return resourcesDict[$.trim($(val).text())];
        })).join('&search[lings][0][]=');
    }

    function buildQueryParams(type){
      params = staticParams();
      // add the type here
      addSearchTypeToParams(params.search, type);
      // add lings here
      addLingsToParams(params.search);
      // return params
      return params;
    }

    // Just save static parameters in somewhere
    function staticParams(){
      return {
        authenticity_token: $('meta[name=csrf-token]').attr('content'),
        search: {
          // will use it for clustering
          advanced_set : {},
          // will use it for compare
          ling_set: {'0': '', '1': ''},
          // put the lings ids here
          lings: {'0': [], '1': [] },
          // static stuff used to prevent any filter on properties
          property_set: {'0': 'any', '1': 'any'},
          lings_property_set: {'0': 'any', '1': 'any'},
          ling_keywords: {'0': null, '1': null},
          property_keywords: {'0': null, '1': null},
          example_fields: {'0': 'description', '1': 'description'},
          example_keywords: {'0': null, '1': null},
          // enable javascript
          javascript: true
        }
      };
        // return "utf8=✓&search[include][ling_0]=1&search[include][property_0]=1&search[include][value_0]=1"+
        //        "&search[include][example_0]=1&search[ling_keywords][0]=&search[property_keywords][1]="+
        //        "&search[property_set][1]=any&search[lings_property_set][1]=any&search[example_fields][0]=description"+
        //        "&search[example_keywords][0]=";
    }

    function analysisURL(){
        return '/groups/' + T.currentGroup + '/searches/preview';
               // '/searches/preview?'+ staticParams() +
               // '&search[lings][0][]=' + currentId +
               // '&search[example_keywords][0]=' + params +
               // buildLingsURL();
    }

    function bindAnalysis(id, type){
      $(document).on('click', id, function (e) {
        if (! $(this).attr("disabled")) {
          // window.open(searchQuery(url));
          // open the modal
          openResultsModal(doAnalysis(type));
        }
      });
    }

    // remove a language from the cache
    function removeLanguage(){
      var item = $(this).parent();

      var name = item.text().substring(1);

      delete resourcesDict[name];

      item.remove();

      checkButtons($('ul#selected-lings li').length);

      evt.preventDefault();
    }

    function removeLanguages() {
      $('#selected-lings li').each( function () {
          var item = $(this);
          item.remove();
      });
      // reset the cache
      resourcesDict = {};

      checkButtons(false);


      evt.preventDefault();
    }

    function setupTypeahead(){

      T.Search.quickTemplate(
        resourceId,
        {type: 'ling', template: 'resource'},
        {nameResolver: nameResolver, onSelection: onLingSelected}
      );
    }

    function nameResolver(){
      return T.groups[T.currentGroup].ling0_name.split(' ').join(' - ');
    }

    function onLingSelected(evt, ling, name){

      if(!resourcesDict[ling.name]){

        resourcesDict[ling.name] = ''+ling.id;

        $('#selected-lings').append(resourceTemplate.render(ling));

        checkButtons(true);
      }

      $('#'+resourceId+'-search-field').typeahead('val', '');

    }

    function loadMap(){
      T.Map.init('ling-map', {name: $('#map').data('name')});
    }

    function openResultsModal(promise){
      // clean the modal content
      $('#analysis-results').empty();

      // open the modal
      $('#analysis-modal').modal('show');

      promise.always(function (page){
        
        // get the promise results filtering part of the page
        var html = $('#results-wrapper', page).html();

        // paste the results in the modal
        $('#analysis-results').html(html);

        // init the page js
        T.Searches.preview.embedInit();
      });
    }

})();

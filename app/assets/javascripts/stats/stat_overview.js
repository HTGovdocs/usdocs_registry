$(document).ready(function(){

  drawAreaChart('assets/stats/num_dig.csv', 
                '# of Digitized Objects',
                'num_digitized');
  drawAreaChart('assets/stats/num_bibs.csv', 
                'Bibliographic Records',
                'num_bibs');
  drawAreaChart('assets/stats/num_sudocs.csv', 
                'SuDoc Class',
                'num_sudocs');

  /* Fill in the select */
  $.get('assets/stats/sudoc_classes.csv', function(csvString){
    var sudoc_classes = csvString.split(',')
    sudoc_classes.forEach(function(sclass, index){
      $('#sudoc_filter').append('<option>'+sclass+'</option>');
    });
  });
    
  $('#sudoc_filter').change(function(){
    sudoc_class = $('#sudoc_filter').val();
    drawAreaChart('assets/stats/num_sudocs.csv', 
                  'SuDoc Class',
                  'num_sudocs',
                  sudoc_class);
  });
});

function drawAreaChart(source_data, title, divid, sclass){
  sclass = sclass || 'Top 10'
  google.charts.load('current', {'packages':['corechart', 'line']});
  google.charts.setOnLoadCallback(function(){
    $.get(source_data, function(csvString) {
        /*google.charts.load('current', {'packages':['corechart', 'area']});*/
        var arrayData = $.csv.toArrays(csvString, {onParseValue: $.csv.hooks.castToScalar});
        var header = arrayData[0]
        /* don't need Month */
        month = header.shift
        var data = new google.visualization.arrayToDataTable(arrayData);
         
        var options = {
          title: title,
          width:"80%",
          height:600,
          isStacked:true
        }; 
        var chart = new google.visualization.AreaChart(document.getElementById(divid));
        //use a DataView to filter 
        if( sclass != 'All' && divid == 'num_sudocs') {
          var view = new google.visualization.DataView(data);
        
          if( sclass == 'Top 10' ){
            view.setColumns([0,1,2,3,4,5,6,7,8,9,10])
          }else{          
            //only the columns that match the selected class 
            view.setColumns([0].concat(header.filter(function(h, index){
                  if( h == sclass ){
                    return index;
                  }
                })
              )//concat
            );
          }
          chart.draw(view, options);
        }else{
          chart.draw(data, options);
        }
    });
  });
}
 

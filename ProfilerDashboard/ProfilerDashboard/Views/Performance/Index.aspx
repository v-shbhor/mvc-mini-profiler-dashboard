﻿<%@ Page Title="Title" Language="C#" Inherits="System.Web.Mvc.ViewPage<System.Collections.Generic.IEnumerable<dynamic>>" MasterPageFile="~/Views/Shared/Site.Master" %>

<asp:Content runat="server" ID="Title" ContentPlaceHolderID="TitleContent">
    Performance Dashboard
</asp:Content>
<asp:Content runat="server" ID="Main" ContentPlaceHolderID="MainContent">
    <div id="visualization" style="width: 100%; height: 450px;">
    </div>
    <h2>Routes (click any route for details)</h2>
    <div id="dataTable">
    </div>
    <h2>Route Details</h2>
    <div id="detailTable">
    </div>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
        google.load('visualization', '1', { packages: ['table', 'corechart'] });
    </script>
    <script type="text/javascript">
    function drawVisualization() {
    	// Populate the data table.
    	var dataTable = new google.visualization.DataTable();

    	dataTable.addColumn('string', 'Route');
    	dataTable.addColumn('number', 'Low');
    	dataTable.addColumn('number', '25%');
    	dataTable.addColumn('number', '75%');
    	dataTable.addColumn('number', 'High');
    	dataTable.addColumn('number', 'Count');
    	dataTable.addColumn('number', 'Average');

    	<% foreach (var row in (IEnumerable<dynamic>)Model) { %>
    	dataTable.addRow(['<%: row.WebRoute %>', <%: row.Low %> , <%: row.BoxLow %> , <%: row.BoxHigh %> , <%: row.High %> , <%: row.Samples %> , <%: row.AvgD %> ]);
    	<% } %>

    	var dataView = new google.visualization.DataView(dataTable);
    	dataView.setColumns([0, 1, 2, 3, 4]);
    	dataView.setRows(0, <%: Model.Count() - 1 < 9 ? Model.Count() - 1 : 9 %> );

    	var table = new google.visualization.Table(document.getElementById('dataTable'));
    	table.draw(dataTable, { page: 'enable', pageSize: 10 });

    	// Draw the chart.
    	var chart = new google.visualization.CandlestickChart(document.getElementById('visualization'));
    	chart.draw(dataView, { legend: 'none', 'title': 'Highest peaks', 'vAxis': { 'title': 'Milliseconds (1000 = 1s)' } });

    	// When someone clicks on a route in the dataTable, call the selectHandler
    	google.visualization.events.addListener(table, 'select', selectHandler);
    	
    	var dataDetail;
    	var detailTable;
    	
    	function selectHandler() {
    		var selection = table.getSelection();
    		
    		// Get the first selected item
    		if (selection.length > 0) {
    			var item = selection[0];
    			
    			if (item.row != null) {
    				// Download details and display sub-table
    				var jqxhr = $.ajax({
    						url: '<%: Url.Action("Details", "Performance") %>',
    						data: { WebRoute: dataTable.getFormattedValue(item.row, 0) },
    						dataType: "json",
    						contentType: 'application/json',
    						async: false,
    						success: function(response) {
    							dataDetail = new google.visualization.DataTable(response);

    							detailTable = new google.visualization.Table(document.getElementById('detailTable'));
    							detailTable.draw(dataDetail, { page: 'enable', pageSize: 10 });
    							
    							// When someone clicks on a route in the dataTable, call the selectHandler
    	                        google.visualization.events.addListener(detailTable, 'select', selectHandler2);
    						},
    						error: function(jqXHR, textStatus, errorThrown) {
    							alert("Request failed: " + textStatus);
    						}
    					});
    			}

    			return false;
    		}
    	}
    	
    	function selectHandler2() {
    		var selection = detailTable.getSelection();
    		
    		// Get the first selected item
    		if (selection.length > 0) {
    			var item = selection[0];
    			
    			window.open('/mini-profiler-results?id=' + dataDetail.getFormattedValue(item.row, 0));
    		}
    	}
    };
    
    google.setOnLoadCallback(drawVisualization);
    </script>
</asp:Content>

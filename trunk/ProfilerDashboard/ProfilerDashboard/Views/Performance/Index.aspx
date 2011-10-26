<%@ Page Title="Title" Language="C#" Inherits="System.Web.Mvc.ViewPage<System.Collections.Generic.IEnumerable<dynamic>>" MasterPageFile="~/Views/Shared/Site.Master" %>
<asp:Content runat="server" ID="Title" ContentPlaceHolderID="TitleContent">
    Performance Dashboard
</asp:Content>
<asp:Content runat="server" ID="Main" ContentPlaceHolderID="MainContent">
<div id="visualization" style="width: 100%; height: 450px;"></div>
<div id="dataTable"></div>

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
    	dataTable.addRow(['<%: row.WebRoute %>', <%: row.Low %> , <%: row.BoxLow %> , <%: row.BoxHigh %> , <%: row.High %> , <%: row.Samples %>, <%: row.AvgD %> ]);
        <% } %>

    	var dataView = new google.visualization.DataView(dataTable);
        dataView.setColumns([0, 1, 2, 3, 4]);
    	dataView.setRows(0, <%: Model.Count() - 1 < 9 ? Model.Count() - 1 : 9 %>);

    	var table = new google.visualization.Table(document.getElementById('dataTable'));
        table.draw(dataTable, { page: 'enable', pageSize: 10 });

        // Draw the chart.
        var chart = new google.visualization.CandlestickChart(document.getElementById('visualization'));
        chart.draw(dataView, { legend: 'none', 'title': 'Highest peaks', 'vAxis': {'title': 'Milliseconds (1000 = 1s)'} });
    };

    google.setOnLoadCallback(drawVisualization);
    </script>
</asp:Content>

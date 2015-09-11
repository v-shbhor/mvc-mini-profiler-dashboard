# What does it do?  #
An ASP.NET MVC dashboard that allows you to monitor the performance of your site using the MVC-Mini-Profiler.

The dashboard will show you the Controller/Views ordered from slowest to fastest using a boxplot.  The box portion of this plot shows you what most of the users experience.  The wick portion shows you the outliers (best and worst).

http://antonvishnyak.files.wordpress.com/2011/09/mvc-mini-profiler-dashboard.png?w=547&h=494

# How do I get started? #
It's just 3 easy steps (and a bonus step):
  1. Download the latest source code from the Source tab (don't have SVN? Try this [Single EXE Download Utility](http://downloadsvn.codeplex.com/))
  1. Open the solution in Visual Studio 2010
  1. Review Globals.ascx.cs, PerformanceController and Performance/Index View
  1. Run the project and click on the "Performance Dashboard" tab to see the output

# What libraries are used in this project? #
This sample is based on:
  * MVC3
  * [MVC-mini-profiler](http://code.google.com/p/mvc-mini-profiler/)
  * [Dapper Micro-ORM](http://code.google.com/p/dapper-dot-net/)
  * [Google Visualization API](http://code.google.com/apis/chart/interactive/docs/gallery/candlestickchart.html)

# How do I set up my SQL Server for logging? #
The sample comes with a pre-configured SqlExpress database that you can use directly for logging.

However, if you would like to set up logging for your own Sql Server, run the following script:

```
create table MiniProfilers
  (
     Id                                   uniqueidentifier not null primary key,
     Name                                 nvarchar(200) not null,
     Started                              datetime not null,
     MachineName                          nvarchar(100) null,
     [User]                               nvarchar(100) null,
     Level                                tinyint null,
     RootTimingId                         uniqueidentifier null,
     DurationMilliseconds                 decimal(7, 1) not null,
     DurationMillisecondsInSql            decimal(7, 1) null,
     HasSqlTimings                        bit not null,
     HasDuplicateSqlTimings               bit not null,
     HasTrivialTimings                    bit not null,
     HasAllTrivialTimings                 bit not null,
     TrivialDurationThresholdMilliseconds decimal(5, 1) null,
     HasUserViewed                        bit not null
  )

GO

create table MiniProfilerTimings
  (
     RowId                               integer primary key identity, -- sqlite: replace identity with autoincrement
     Id                                  uniqueidentifier not null,
     MiniProfilerId                      uniqueidentifier not null,
     ParentTimingId                      uniqueidentifier null,
     Name                                nvarchar(200) not null,
     Depth                               smallint not null,
     StartMilliseconds                   decimal(7, 1) not null,
     DurationMilliseconds                decimal(7, 1) not null,
     DurationWithoutChildrenMilliseconds decimal(7, 1) not null,
     SqlTimingsDurationMilliseconds      decimal(7, 1) null,
     IsRoot                              bit not null,
     HasChildren                         bit not null,
     IsTrivial                           bit not null,
     HasSqlTimings                       bit not null,
     HasDuplicateSqlTimings              bit not null,
     ExecutedReaders                     smallint not null,
     ExecutedScalars                     smallint not null,
     ExecutedNonQueries                  smallint not null
  )

GO

create table MiniProfilerSqlTimings
  (
     RowId                          integer primary key identity, -- sqlite: replace identity with autoincrement
     Id                             uniqueidentifier not null,
     MiniProfilerId                 uniqueidentifier not null,
     ParentTimingId                 uniqueidentifier not null,
     ExecuteType                    tinyint not null,
     StartMilliseconds              decimal(7, 1) not null,
     DurationMilliseconds           decimal(7, 1) not null,
     FirstFetchDurationMilliseconds decimal(7, 1) null,
     IsDuplicate                    bit not null,
     StackTraceSnippet              nvarchar(200) not null,
     CommandString                  nvarchar(max) not null -- sqlite: remove (max)
  )

GO

create table MiniProfilerSqlTimingParameters
  (
     MiniProfilerId    uniqueidentifier not null,
     ParentSqlTimingId uniqueidentifier not null,
     Name              varchar(130) not null,
     DbType            varchar(50) null,
     Size              int null,
     Value             nvarchar(max) null -- sqlite: remove (max)
  )
```

# Where is it used? #
The dashboard is used on http://jobseriously.com.

If you are using it on your site, leave a comment and we will add your name to the list of sites that use the performance dashboard.


---


Original article is located on [Anton Vishnyak's Blog](http://antonvishnyak.wordpress.com/2011/09/07/building-an-mvc-mini-profiler-dashboard/)

Based on work for [JobSeriously a new way to search for a job online](http://jobseriously.com).

<a href='Hidden comment: 
This text will be removed from the rendered page.
'></a>
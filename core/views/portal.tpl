<!doctype html>
<html lang="nl">
  <head>
    <meta charset="utf-8">
    <title>vod_statistic_portal</title>
    <link href="../../static/css/bootstrap/3.0.0/bootstrap.min.css" rel="stylesheet">
    <script src="../../static/js/jquery-1.11.1.min.js"></script>
    <script src="../../static/js/bootstrap/3.0.0/bootstrap.min.js"></script>
    <script type="text/javascript" src="../../static/js/Chart.js"></script>
  </head>

  <body onLoad="init()">
    <div class="jumbotron">
      <div class="container">
        <h1>聚好看统计分析Portal
          <a class="btn btn-xs btn-primary" href="history">更新2014-12-16</a></h1>
        <p>聚好看是海信电视的视频服务，这个页面用来展示聚好看系统中的一些关键的数据统计报表。</p>
      </div>
    </div>

    <div class="container">
      <!-- Example row of columns -->
      <div class="row">
        <div class="col-md-4">
          <h2>用户统计</h2>
          <p>统计聚好看系统中终端用户的相关数据，包括用户总数，活跃用户数，点播用户数，并且根据合作方或者机型进行分类统计</p>
          <p><a class="btn btn-default" href="charts/users" role="button">View details &raquo;</a></p>
        </div>
        <div class="col-md-4">
          <h2>频次统计</h2>
          <p>统计聚好看系统中终端的点播行为的相关数据，包括用户点播次数，并且根据合作方和机型进行分类统计</p><br>
          <p><a class="btn btn-default" href="charts/times" role="button">View details &raquo;</a></p>
        </div>
        <div class="col-md-4">
          <h2>时长统计</h2>
          <p>统计聚好看系统中终端点播时长的相关数据，包括点播总时长和每日人均点播时长</p>
          <br>
          <p><a class="btn btn-default" href="charts/duration" role="button">View details &raquo;</a></p>
        </div>
      </div>
      <hr>

      <script type="text/javascript">

      window.onLoad = function() {
      init();
      };

      function init() {
          init_play_times()
      }

      function init_play_times() {
          var ctx = $("#myChart").get(0).getContext("2d");

          var data = {
              labels: [
              % for day in days[:-1]:
              '{{day}}',
              % end
              '{{days[-1]}}'  
              ],
              datasets: [
                  {
                      fillColor: "rgba(220,220,220,0.5)",
                      strokeColor: "rgba(220,220,220,1)",
                      pointColor: "rgba(220,220,220,1)",
                      pointStrokeColor: "#fff",
                      data: {{data}}
                  },
                  //{
                  //fillColor: "rgba(151,187,205,0.5)",
                  //strokeColor: "rgba(151,187,205,1)",
                  //pointColor: "rgba(151,187,205,1)",
                  //pointStrokeColor: "#fff",
                  //data: [28, 48, 40, 19, 96, 27, 100]
                  //}
              ]
          }

          var myNewChart = new Chart(ctx).Line(data);
      }

    </script>
      <div>
        <section>
          <article>
            <p><span class="label label-default">联网总用户数</span></p>
            <canvas id="myChart" width="1000" height="200">
            </canvas>
          </article>
        </section>
      </div>
      <br>
      <footer>
        <p>&copy; Denny(wanziforever@163.com) 2014</p>
      </footer>
    </div> <!-- /container -->
  </body>
</html>

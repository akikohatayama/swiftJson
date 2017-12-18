<?php
 
$result = array();
 
try{
    //データーベースホスト
    $server   = "mysqlxxx.phy.lolipop.jp";
    //ユーザー名              
    $user     = "LAxxxxxxxx";
    //パスワード                           
    $pass     = "yyyyyyyy";
    //データベース名                           
    $database = "LAxxxxxx-dbname";         
 
    $dbh = new PDO("mysql:host=" . $server . "; dbname=" . $database . ";charset=utf8;", $user, $pass );
 
    if ($dbh == null) {
        // echo('接続失敗');
    } else {
        // echo('接続成功');
 
        $sql = 'SELECT * FROM hhhhhhhhhh ORDER BY date';
 
        foreach ($dbh -> query($sql) as $key => $row) {
            if ($key == 0){
                $result = array(
                            array(
                                "date" => $row["date"],
                                "title" => $row["title"],
                                "contents" => $row["contents"]
                            )
                        );
            }else{
                $result = array_merge($result,array(
                                                array(
                                                    "date" => $row["date"],
                                                    "title" => $row["title"],
                                                    "contents" => $row["contents"]
                                                )
                                            )
                                        );
            }
        }
    }
    //データベース接続切断
    $dbh = null;
}catch(PDOException $e){
    // echo('Connection failed:'.$e->getMessage());
    die();
}
echo json_encode($result, JSON_UNESCAPED_UNICODE);
?>

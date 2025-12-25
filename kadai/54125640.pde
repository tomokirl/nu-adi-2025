/*
デザイン情報学特論　第13回課題
54125640 原田知季
コードをProcessingで実行すると青と緑のDNAを再現した二重らせん構造が出現します。
カーソルを動かすことで視点が動き、クリックすることで活性化をイメージして色が赤と紫に変わります。
 */

float angle = 0;         // らせんの回転角度
float currentRadius = 100; // 現在のらせんの半径
float targetRadius = 100;  // 目標とする半径（クリックで変化）

void setup() {
  // 3Dモード (P3D) を指定
  size(1280, 720, P3D);
  // 線を滑らかにする
  smooth(8); 
  // 球体の描画精度（デフォルトより少し下げることでパフォーマンス向上）
  sphereDetail(12); 
}

void draw() {
  background(10, 20, 40); // 深い青色の背景
  
  // 1. インタラクティブ：照明の設定
  // マウスの位置に応じて光源が移動するように見える演出
  ambientLight(60, 60, 60);
  pointLight(255, 255, 255, mouseX, mouseY, 200);

  // 2. インタラクティブ：マウス移動による視点回転
  translate(width/2, height/2, 0); // 画面中央を原点に
  // マウスのY座標でX軸回転、X座標でY軸回転させる
  float rotX = map(mouseY, 0, height, -PI/2, PI/2);
  float rotY = map(mouseX, 0, width, -PI, PI);
  rotateX(rotX);
  rotateY(rotY + frameCount * 0.005); // ゆっくりと自動回転も加える

  // 3. インタラクティブ：クリックによる半径の変化（呼吸エフェクト）
  if (mousePressed) {
    targetRadius = 200; // クリック時は半径を大きく
  } else {
    targetRadius = 100; // 通常時
  }
  // 現在の半径を目標半径に滑らかに近づける（線形補間）
  currentRadius = lerp(currentRadius, targetRadius, 0.1);


  // --- DNA構造の描画ループ ---
  float h = -height/1.5; // 描画開始の高さ
  
  // ループで下から上へ積み上げていく
  for (int i = 0; i < 150; i++) {
    // 角度の計算（iが進むにつれて回転させる）
    float theta = angle + i * 0.15;
    
    float y = h + i * 8; // Y座標（高さ）

    // 鎖1の座標計算 (三角関数)
    float x1 = cos(theta) * currentRadius;
    float z1 = sin(theta) * currentRadius;
    
    // 鎖2の座標計算 (鎖1からPI=180度ずらす)
    float x2 = cos(theta + PI) * currentRadius;
    float z2 = sin(theta + PI) * currentRadius;

    // 色の決定（高さとクリック状態によって変化）
    color c1, c2;
    if (mousePressed) {
      // クリック時は活性化
      c1 = color(100 + i, 50, 200);
      c2 = color(200, 50, 100 + i);
    } else {
      // 通常時は落ち着いた青/緑（バイオカラー）
      c1 = color(50, 150 + i, 255);
      c2 = color(50, 255, 150 + i);
    }

    noStroke();
    
    // 鎖1のヌクレオチド（球体）を描画
    pushMatrix();
    translate(x1, y, z1);
    fill(c1);
    sphere(5); 
    popMatrix();

    // 鎖2のヌクレオチド（球体）を描画
    pushMatrix();
    translate(x2, y, z2);
    fill(c2);
    sphere(5);
    popMatrix();

    // 塩基対（2つの鎖をつなぐハシゴ部分）を描画
    stroke(255, 100); // 半透明の白
    strokeWeight(2);
    line(x1, y, z1, x2, y, z2);
  }
  
  // 全体の回転角度を少しずつ進める
  angle += 0.02;
}

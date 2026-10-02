// rust-slint-counter — 用 Slint 构建的跨平台桌面计数器
// 运行: cargo run
slint::include_modules!();

fn main() {
    let app = MainWindow::new().expect("创建窗口失败");
    app.on_increment(|| {
        // 真实项目里可在这里挂业务逻辑
    });
    app.run().expect("运行 GUI 失败");
}

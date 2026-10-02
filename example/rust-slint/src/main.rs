// rust-slint-counter — 用 Slint 构建的跨平台桌面计数器
// 运行: cargo run
slint::include_modules!();

/// 纯函数：把计数按 delta 调整。抽成独立函数便于单元测试。
fn step(counter: i32, delta: i32) -> i32 {
    counter + delta
}

fn main() {
    let app = MainWindow::new().expect("创建窗口失败");

    // UI 里的 +/- 按钮触发 increment(delta)，在这里落到纯逻辑上。
    let weak = app.as_weak();
    app.on_increment(move |delta| {
        let app = weak.upgrade().expect("窗口已关闭");
        app.set_counter(step(app.get_counter(), delta));
    });

    app.run().expect("运行 GUI 失败");
}

#[cfg(test)]
mod tests {
    use super::step;

    #[test]
    fn step_adds_delta() {
        assert_eq!(step(1, 1), 2);
    }

    #[test]
    fn step_subtracts_delta() {
        assert_eq!(step(1, -1), 0);
    }
}

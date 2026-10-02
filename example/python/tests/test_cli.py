from typer.testing import CliRunner

from py_task_cli.main import app

runner = CliRunner()


def test_add_and_ls(tmp_path, monkeypatch):
    # 通过环境变量把数据文件指向临时目录，实现真正隔离
    # （不要依赖 HOME：Windows 上 Path.home() 读的是 USERPROFILE）。
    monkeypatch.setenv("PY_TASK_CLI_STORE", str(tmp_path / "tasks.json"))

    result = runner.invoke(app, ["add", "write docs"])
    assert result.exit_code == 0
    assert "added: write docs" in result.output

    result = runner.invoke(app, ["ls"])
    assert result.exit_code == 0
    assert "[ ] 1 write docs" in result.output


def test_ls_empty(tmp_path, monkeypatch):
    monkeypatch.setenv("PY_TASK_CLI_STORE", str(tmp_path / "none.json"))
    result = runner.invoke(app, ["ls"])
    assert result.exit_code == 0
    assert result.output.strip() == ""

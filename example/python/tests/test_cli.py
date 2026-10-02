from typer.testing import CliRunner

from py_task_cli.main import APP

runner = CliRunner()


def test_add_and_ls(tmp_path, monkeypatch):
    monkeypatch.setenv("HOME", str(tmp_path))
    runner.invoke(APP, ["add", "write docs"])
    result = runner.invoke(APP, ["ls"])
    assert "write docs" in result.output
    assert "[ ] 1 write docs" in result.output

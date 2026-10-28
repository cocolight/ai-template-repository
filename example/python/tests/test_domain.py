from py_task_cli.domain import add_task, render


def test_add_task_appends_with_incrementing_id():
    tasks = []
    first = add_task(tasks, "write docs")
    second = add_task(tasks, "review PR")
    assert [t["id"] for t in tasks] == [1, 2]
    assert first["name"] == "write docs" and first["done"] is False
    assert second["id"] == 2


def test_render_marks_done_state():
    tasks = [{"id": 1, "name": "a", "done": False}, {"id": 2, "name": "b", "done": True}]
    assert render(tasks) == ["[ ] 1 a", "[x] 2 b"]

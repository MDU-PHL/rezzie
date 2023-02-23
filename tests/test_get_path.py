import rezzie


def test_get_path():
    path = rezzie.get_path(rezzie, "data", "seq.fasta")
    assert path.read_text() == ">seq1\nAGCTGG\n"

from jaypore_ci import jci

with jci.Pipeline(image='mydocker/image') as p:
    p.job("Black", "black --check .")
    p.job("Pylint", "pylint mycode/ tests/")
    p.job("PyTest", "pytest tests/")
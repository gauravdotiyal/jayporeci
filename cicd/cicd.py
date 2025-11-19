from jaypore_ci import jci

with jci.Pipeline(image="python:3.11") as p:
    p.job("Black",  ["python", "-c", "print(1+1)"])
    # p.job("Pylint", ["bash", "-c", "pip install pylint && pylint ."])
    # p.job("PyTest", ["bash", "-c", "pip install pytest && pytest"])

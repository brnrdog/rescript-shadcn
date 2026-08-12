"""Compare each xote example against the base example of the same name.

Structure is the thing worth comparing: which components are rendered, in what
order, with which classes and which visible text. Dialect differences (`class`
vs `className`, `React.string`) are normalised away first.
"""
import os, re, sys, json

ROOT = "/home/user/rescript-shadcn"
BASE = f"{ROOT}/registry/base/examples"
XOTE = f"{ROOT}/registry/xote/examples"


def tags(src: str):
    return re.findall(r"<([A-Za-z][\w.]*)", src)


def classes(src: str):
    found = re.findall(r'class(?:Name)?="([^"]*)"', src)
    return [" ".join(sorted(c.split())) for c in found]


def texts(src: str):
    """Visible string literals, minus ids, classes and other attribute values."""
    stripped = re.sub(r'\b[\w]+="[^"]*"', "", src)
    return [t for t in re.findall(r'"([^"\n]{2,})"', stripped) if not t.startswith("cn-")]


def shape(src: str):
    return {"tags": tags(src), "classes": classes(src), "texts": texts(src)}


def diff(name):
    base_path, xote_path = f"{BASE}/{name}.res", f"{XOTE}/{name}.res"
    if not os.path.exists(base_path) or not os.path.exists(xote_path):
        return None
    b, x = shape(open(base_path).read()), shape(open(xote_path).read())

    problems = []
    # Components rendered, ignoring the wrappers each dialect needs.
    ignore = {"View.For", "React.Fragment"}
    bt = [t for t in b["tags"] if t not in ignore]
    xt = [t for t in x["tags"] if t not in ignore]
    if bt != xt:
        missing = [t for t in bt if t not in xt]
        extra = [t for t in xt if t not in bt]
        if missing or extra:
            problems.append(f"tags -{missing} +{extra}")
        elif len(bt) != len(xt):
            problems.append(f"tag count {len(bt)} vs {len(xt)}")

    missing_classes = [c for c in b["classes"] if c not in x["classes"]]
    if missing_classes:
        problems.append(f"classes missing {missing_classes[:3]}")

    missing_text = [t for t in b["texts"] if t not in x["texts"]]
    if missing_text:
        problems.append(f"text missing {missing_text[:3]}")

    return problems or None


def main():
    names = sorted(f[:-4] for f in os.listdir(XOTE) if f.endswith(".res"))
    report = {}
    for name in names:
        problems = diff(name)
        if problems:
            report[name] = problems

    print(f"compared {len(names)} examples, {len(report)} differ")
    kinds = {}
    for problems in report.values():
        for problem in problems:
            kinds[problem.split()[0]] = kinds.get(problem.split()[0], 0) + 1
    print("by kind:", kinds)
    if "-v" in sys.argv:
        for name, problems in list(report.items())[: int(sys.argv[-1]) if sys.argv[-1].isdigit() else 25]:
            print(f"  {name}: {'; '.join(problems)[:160]}")
    json.dump(report, open("/tmp/claude-0/-home-user-rescript-shadcn/70412dc9-4fd5-5e13-8f4e-c40c72d01a94/scratchpad/fidelity.json", "w"), indent=1)


if __name__ == "__main__":
    main()

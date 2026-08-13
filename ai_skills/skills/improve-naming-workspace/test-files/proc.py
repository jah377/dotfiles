"""Data processing utilities for the sales pipeline."""
from dataclasses import dataclass
from typing import Optional
import pandas as pd


@dataclass
class Cfg:
    host: str
    p: int
    db: str
    use_ssl: bool = True


class DataProc:
    """Handles loading and transformation of raw sales records."""

    def __init__(self, cfg: Cfg, n: int = 1000):
        self.cfg = cfg
        self.d = None          # will hold the loaded dataframe
        self.res = []          # accumulates processed rows
        self.n = n             # max rows to process

    @property
    def ok(self) -> bool:
        """Returns True if data has been loaded and is non-empty."""
        return self.d is not None and len(self.d) > 0

    def load(self, f: str) -> None:
        """Load raw CSV data from the given file path into self.d."""
        self.d = pd.read_csv(f)

    def run(self, drop_null: bool = True) -> pd.DataFrame:
        """Filter, clean, and aggregate the loaded sales records.

        Applies null dropping, clips to self.n rows, groups by region,
        and sums revenue. Stores result in self.res and returns it.
        """
        if not self.ok:
            raise RuntimeError("No data loaded")
        df = self.d.copy()
        if drop_null:
            df = df.dropna()
        df = df.head(self.n)
        result = df.groupby("region")["revenue"].sum().reset_index()
        self.res = result
        return result

    def save(self, out: str) -> None:
        """Write self.res to a CSV file at the given path."""
        if len(self.res) == 0:
            raise RuntimeError("Nothing to save")
        self.res.to_csv(out, index=False)


def chk(df: pd.DataFrame, cols: list[str]) -> bool:
    """Return True if all required columns are present in the dataframe."""
    return all(c in df.columns for c in cols)


def fmt(val: float, dec: int = 2) -> str:
    """Format a float as a currency string with the given decimal places."""
    return f"${val:,.{dec}f}"

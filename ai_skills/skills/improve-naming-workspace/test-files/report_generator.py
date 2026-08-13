"""Generates monthly sales reports from aggregated pipeline data."""
from pathlib import Path
from datetime import date
import pandas as pd


class MonthlySalesReport:
    """Builds and exports a formatted monthly sales report."""

    def __init__(self, report_month: date, output_dir: Path):
        self.report_month = report_month
        self.output_dir = output_dir
        self.revenue_by_region: pd.DataFrame | None = None
        self.top_products: list[str] = []

    @property
    def is_ready(self) -> bool:
        """Return True if the report has data loaded and is ready to export."""
        return self.revenue_by_region is not None

    def load_revenue_data(self, source_path: Path) -> None:
        """Load aggregated revenue data from a CSV at source_path."""
        self.revenue_by_region = pd.read_csv(source_path)

    def set_top_products(self, products: list[str]) -> None:
        """Set the list of top-performing product names for the report header."""
        self.top_products = products

    def export_as_csv(self, filename: str | None = None) -> Path:
        """Write the revenue data to a CSV in output_dir and return the path."""
        if not self.is_ready:
            raise RuntimeError("No data loaded")
        name = filename or f"sales_{self.report_month.strftime('%Y_%m')}.csv"
        destination = self.output_dir / name
        self.revenue_by_region.to_csv(destination, index=False)
        return destination


def compute_growth_rate(current: float, previous: float) -> float:
    """Return the percentage growth from previous to current period."""
    if previous == 0:
        return 0.0
    return (current - previous) / previous * 100


def format_currency(amount: float, decimal_places: int = 2) -> str:
    """Format a numeric amount as a USD currency string."""
    return f"${amount:,.{decimal_places}f}"


def filter_to_active_regions(
    dataframe: pd.DataFrame,
    region_column: str = "region",
    min_revenue: float = 0.0,
) -> pd.DataFrame:
    """Return rows where the region column has revenue above min_revenue."""
    return dataframe[dataframe[region_column] > min_revenue]

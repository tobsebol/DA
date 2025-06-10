#%%
import pandas as pd
#%%
import matplotlib.pyplot as plt

#%%
# 1. Daten laden
sales = pd.read_csv("Data Dataanalysis/sales_data_multi_customers_per_day.csv", parse_dates=["date"])
customers = pd.read_csv("Data Dataanalysis/customer_information.csv")
#%%
# 2. Merge Sales ↔ Kunden
df = sales.merge(customers, on="customer_id")
#%%
# 3. Gesamte Verkaufsmenge pro Region
region_sales = df.groupby("region")["units"].sum().sort_values(ascending=False)
print("🔹 Verkaufsvolumen je Region:")
print(region_sales, "\n")
#%%
# 4. Durchschnittlicher Umsatz pro Kunde in jeder Region
region_avg = df.groupby("region")["units"].mean()
print("🔹 Ø Verkaufseinheiten pro Kunde je Region:")
print(region_avg, "\n")
#%%
# 5. Verkaufsverteilung nach Branche
branch_sales = df.groupby("branch")["units"].sum().sort_values(ascending=False)
print("🔹 Verkaufsvolumen je Branche:")
print(branch_sales.head(10), "\n")
#%%
# 6. Korrelation: Mitarbeiterzahl vs. Verkaufseinheiten
#    (aggregieren auf Kunden-Ebene)
cust_agg = df.groupby(["customer_id", "employees"])["units"].sum().reset_index()
corr = cust_agg["employees"].corr(cust_agg["units"])
print(f"🔹 Korrelation Mitarbeiterzahl ↔ Verkaufseinheiten: {corr:.2f}\n")

#%%
# 7. Visualisierungen

# a) Balkendiagramm: Region
plt.figure(figsize=(6,4))
region_sales.plot(kind="bar", title="Verkaufsvolumen nach Region")
plt.ylabel("Einheiten")
plt.tight_layout()
plt.show()

# b) Balkendiagramm: Top-5 Branchen
plt.figure(figsize=(6,4))
branch_sales.head(5).plot(kind="bar", title="Top 5 Branchen nach Verkaufsvolumen")
plt.ylabel("Einheiten")
plt.tight_layout()
plt.show()

# c) Scatter-Plot Mitarbeiterzahl vs. Verkauf
plt.figure(figsize=(6,4))
plt.scatter(cust_agg["employees"], cust_agg["units"], alpha=0.6)
plt.title("Mitarbeiterzahl vs. Gesamtverkauf pro Kunde")
plt.xlabel("Anzahl Mitarbeiter")
plt.ylabel("Verkaufseinheiten")
plt.tight_layout()
plt.show()
# %%

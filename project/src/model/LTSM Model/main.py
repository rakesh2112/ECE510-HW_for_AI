
import os
import numpy as np
import pandas as pd
from datetime import datetime
from sklearn.preprocessing import StandardScaler
from tensorflow import keras

# === Setup ===
sequence_len = 60
TRAIN_SPLIT = 0.95
stock_scalers = {}
stock_test_sets = {}

stock_files = ["MicrosoftStock.csv"]  # Add more CSV files as needed
data_dir = os.path.dirname(__file__)

X_all, y_all = [], []

# === Load and preprocess all stocks ===
for file in stock_files:
    ticker = os.path.splitext(file)[0]
    df = pd.read_csv(os.path.join(data_dir, file))
    df['date'] = pd.to_datetime(df['date'])
    df = df.sort_values(by='date')
    close_data = df[['close']]
    dataset = close_data.values
    training_data_len = int(len(dataset) * TRAIN_SPLIT)
    
    scaler = StandardScaler()
    scaled_data = scaler.fit_transform(dataset)
    stock_scalers[ticker] = scaler

    training_data = scaled_data[:training_data_len]
    for i in range(sequence_len, len(training_data)):
        X_all.append(training_data[i-sequence_len:i, 0])
        y_all.append(training_data[i, 0])
    
    test_data = scaled_data[training_data_len - sequence_len:]
    stock_test_sets[ticker] = (test_data, df[training_data_len:])

X_all = np.array(X_all)
y_all = np.array(y_all)
X_all = np.reshape(X_all, (X_all.shape[0], X_all.shape[1], 1))

# === Build model (unchanged structure) ===
model = keras.models.Sequential([
    keras.layers.LSTM(64, return_sequences=True, input_shape=(X_all.shape[1], 1)),
    keras.layers.LSTM(64),
    keras.layers.Dense(128, activation="relu"),
    keras.layers.Dropout(0.5),
    keras.layers.Dense(1)
])
model.compile(optimizer="adam", loss="mae", metrics=[keras.metrics.RootMeanSquaredError()])
model.fit(X_all, y_all, epochs=20, batch_size=32)

# === Save to daily folder ===
today = datetime.now().strftime("%Y-%m-%d")
save_dir = os.path.join(os.path.dirname(data_dir), "trained_models", today)
os.makedirs(save_dir, exist_ok=True)
model.save(os.path.join(save_dir, "multi_stock_model.h5"))

import joblib
for ticker, scaler in stock_scalers.items():
    joblib.dump(scaler, os.path.join(save_dir, f"{ticker}_scaler.save"))

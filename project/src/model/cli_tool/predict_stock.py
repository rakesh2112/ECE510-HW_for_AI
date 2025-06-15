
import sys
import os
import joblib
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from tensorflow import keras

def predict(stock_name, model_date):
    base_path = os.path.dirname(os.path.dirname(__file__))
    model_dir = os.path.join(base_path, "trained_models", model_date)

    model = keras.models.load_model(os.path.join(model_dir, "multi_stock_model.h5"))
    scaler = joblib.load(os.path.join(model_dir, f"{stock_name}_scaler.save"))

    csv_path = os.path.join(base_path, "LTSM Model", f"{stock_name}.csv")
    df = pd.read_csv(csv_path)
    df['date'] = pd.to_datetime(df['date'])
    df = df.sort_values(by='date')

    sequence_len = 60
    close_data = df[['close']]
    dataset = scaler.transform(close_data.values)
    test_data = dataset[-(len(dataset) - int(len(dataset) * 0.95) + sequence_len):]

    X_test = []
    for i in range(sequence_len, len(test_data)):
        X_test.append(test_data[i-sequence_len:i, 0])
    X_test = np.array(X_test)
    X_test = np.reshape(X_test, (X_test.shape[0], X_test.shape[1], 1))

    predictions = model.predict(X_test)
    predictions = scaler.inverse_transform(predictions)

    test_df = df[int(len(df) * 0.95):].reset_index(drop=True)
    test_df["Predictions"] = predictions

    plt.figure(figsize=(12,6))
    plt.plot(test_df["date"], test_df["close"], label="Actual")
    plt.plot(test_df["date"], test_df["Predictions"], label="Predicted")
    plt.title(f"{stock_name} Prediction ({model_date})")
    plt.legend()
    plt.show()

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python predict_stock.py STOCK_NAME YYYY-MM-DD")
    else:
        predict(sys.argv[1], sys.argv[2])

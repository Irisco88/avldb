-- +goose Up
-- +goose StatementBegin
CREATE TABLE rawdatas
(
    timestamp DateTime64(3) DEFAULT now(),
    imei      String,
    payload   String
) ENGINE = MergeTree()
      ORDER BY (timestamp)
      SETTINGS index_granularity = 8192;

-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TABLE IF EXISTS rawdatas;
-- +goose StatementEnd

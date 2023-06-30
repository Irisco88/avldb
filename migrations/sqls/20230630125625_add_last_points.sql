-- +goose Up
-- +goose StatementBegin
CREATE OR REPLACE VIEW lastpoints AS
SELECT DISTINCT ON (imei) *
FROM avlpoints
ORDER BY imei, timestamp DESC;
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP VIEW IF EXISTS lastpoints;
-- +goose StatementEnd

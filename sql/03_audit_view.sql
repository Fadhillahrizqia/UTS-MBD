SET ROLE data_engineer;

ALTER DEFAULT PRIVILEGES FOR ROLE data_engineer IN SCHEMA salam
  GRANT USAGE, SELECT ON SEQUENCES TO backend_dev;

CREATE TABLE salam.audit_log (
  id         BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  waktu      TIMESTAMP NOT NULL DEFAULT now(),
  db_user    TEXT      NOT NULL DEFAULT current_user,
  aksi       TEXT      NOT NULL,
  nim        VARCHAR(10),
  data_lama  JSONB,
  data_baru  JSONB
);

CREATE OR REPLACE FUNCTION salam.fn_audit_mahasiswas() RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO salam.audit_log (aksi, nim, data_baru)
    VALUES (TG_OP, NEW.nim, to_jsonb(NEW));
    RETURN NEW;
  ELSIF TG_OP = 'UPDATE' THEN
    INSERT INTO salam.audit_log (aksi, nim, data_lama, data_baru)
    VALUES (TG_OP, NEW.nim, to_jsonb(OLD), to_jsonb(NEW));
    RETURN NEW;
  ELSE
    INSERT INTO salam.audit_log (aksi, nim, data_lama)
    VALUES (TG_OP, OLD.nim, to_jsonb(OLD));
    RETURN OLD;
  END IF;
END;
$$;

CREATE TRIGGER trg_audit_mahasiswas
AFTER INSERT OR UPDATE OR DELETE ON salam.mahasiswas
FOR EACH ROW EXECUTE FUNCTION salam.fn_audit_mahasiswas();

CREATE VIEW salam.v_mahasiswa_aktif AS
SELECT nim, nama, email, angkatan, ipk
FROM salam.mahasiswas
WHERE status = 'aktif';

RESET ROLE;

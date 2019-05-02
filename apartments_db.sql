--
-- PostgreSQL database dump
--

-- Dumped from database version 11.2 (Debian 11.2-1.pgdg90+1)
-- Dumped by pg_dump version 11.2 (Debian 11.2-1.pgdg90+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE ONLY public.numofresults DROP CONSTRAINT numofresults_pkey;
ALTER TABLE ONLY public.apartments DROP CONSTRAINT apartments_pkey;
ALTER TABLE public.numofresults ALTER COLUMN result_id DROP DEFAULT;
ALTER TABLE public.apartments ALTER COLUMN apartment_id DROP DEFAULT;
DROP SEQUENCE public.numofresults_result_id_seq;
DROP TABLE public.numofresults;
DROP SEQUENCE public.apartments_apartment_id_seq;
DROP TABLE public.apartments;
SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: apartments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.apartments (
    apartment_id integer NOT NULL,
    addr character varying(200) NOT NULL,
    price character varying(50)
);


ALTER TABLE public.apartments OWNER TO postgres;

--
-- Name: apartments_apartment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.apartments_apartment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.apartments_apartment_id_seq OWNER TO postgres;

--
-- Name: apartments_apartment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.apartments_apartment_id_seq OWNED BY public.apartments.apartment_id;


--
-- Name: numofresults; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.numofresults (
    result_id integer NOT NULL,
    num integer
);


ALTER TABLE public.numofresults OWNER TO postgres;

--
-- Name: numofresults_result_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.numofresults_result_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.numofresults_result_id_seq OWNER TO postgres;

--
-- Name: numofresults_result_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.numofresults_result_id_seq OWNED BY public.numofresults.result_id;


--
-- Name: apartments apartment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.apartments ALTER COLUMN apartment_id SET DEFAULT nextval('public.apartments_apartment_id_seq'::regclass);


--
-- Name: numofresults result_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.numofresults ALTER COLUMN result_id SET DEFAULT nextval('public.numofresults_result_id_seq'::regclass);


--
-- Data for Name: apartments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.apartments (apartment_id, addr, price) FROM stdin;
\.


--
-- Data for Name: numofresults; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.numofresults (result_id, num) FROM stdin;
\.


--
-- Name: apartments_apartment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.apartments_apartment_id_seq', 1, false);


--
-- Name: numofresults_result_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.numofresults_result_id_seq', 1, false);


--
-- Name: apartments apartments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.apartments
    ADD CONSTRAINT apartments_pkey PRIMARY KEY (apartment_id);


--
-- Name: numofresults numofresults_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.numofresults
    ADD CONSTRAINT numofresults_pkey PRIMARY KEY (result_id);


--
-- PostgreSQL database dump complete
--


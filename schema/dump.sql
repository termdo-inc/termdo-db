--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5 (Debian 17.5-1.pgdg120+1)
-- Dumped by pg_dump version 17.5 (Debian 17.5-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: account; Type: TABLE; Schema: public; Owner: termdo_admin
--

CREATE TABLE public.account (
    account_id integer NOT NULL,
    username character varying(32) NOT NULL,
    password character varying(60) NOT NULL
);


ALTER TABLE public.account OWNER TO termdo_admin;

--
-- Name: account_account_id_seq; Type: SEQUENCE; Schema: public; Owner: termdo_admin
--

CREATE SEQUENCE public.account_account_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.account_account_id_seq OWNER TO termdo_admin;

--
-- Name: account_account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: termdo_admin
--

ALTER SEQUENCE public.account_account_id_seq OWNED BY public.account.account_id;


--
-- Name: task; Type: TABLE; Schema: public; Owner: termdo_admin
--

CREATE TABLE public.task (
    task_id integer NOT NULL,
    account_id integer NOT NULL,
    title character varying(64) NOT NULL,
    description character varying(1024),
    is_completed boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.task OWNER TO termdo_admin;

--
-- Name: task_task_id_seq; Type: SEQUENCE; Schema: public; Owner: termdo_admin
--

CREATE SEQUENCE public.task_task_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.task_task_id_seq OWNER TO termdo_admin;

--
-- Name: task_task_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: termdo_admin
--

ALTER SEQUENCE public.task_task_id_seq OWNED BY public.task.task_id;


--
-- Name: account account_id; Type: DEFAULT; Schema: public; Owner: termdo_admin
--

ALTER TABLE ONLY public.account ALTER COLUMN account_id SET DEFAULT nextval('public.account_account_id_seq'::regclass);


--
-- Name: task task_id; Type: DEFAULT; Schema: public; Owner: termdo_admin
--

ALTER TABLE ONLY public.task ALTER COLUMN task_id SET DEFAULT nextval('public.task_task_id_seq'::regclass);


--
-- Data for Name: account; Type: TABLE DATA; Schema: public; Owner: termdo_admin
--

COPY public.account (account_id, username, password) FROM stdin;
\.


--
-- Data for Name: task; Type: TABLE DATA; Schema: public; Owner: termdo_admin
--

COPY public.task (task_id, account_id, title, description, is_completed, created_at, updated_at) FROM stdin;
\.


--
-- Name: account_account_id_seq; Type: SEQUENCE SET; Schema: public; Owner: termdo_admin
--

SELECT pg_catalog.setval('public.account_account_id_seq', 1, false);


--
-- Name: task_task_id_seq; Type: SEQUENCE SET; Schema: public; Owner: termdo_admin
--

SELECT pg_catalog.setval('public.task_task_id_seq', 1, false);


--
-- Name: account account_pkey; Type: CONSTRAINT; Schema: public; Owner: termdo_admin
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_pkey PRIMARY KEY (account_id);


--
-- Name: account account_username_key; Type: CONSTRAINT; Schema: public; Owner: termdo_admin
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_username_key UNIQUE (username);


--
-- Name: task task_pkey; Type: CONSTRAINT; Schema: public; Owner: termdo_admin
--

ALTER TABLE ONLY public.task
    ADD CONSTRAINT task_pkey PRIMARY KEY (task_id);


--
-- Name: task task_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: termdo_admin
--

ALTER TABLE ONLY public.task
    ADD CONSTRAINT task_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.account(account_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

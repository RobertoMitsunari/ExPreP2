create database ExPreP2
use ExPreP2

select * from Cliente
insert into Cliente values(1007,	'Luciano Britto',	NULL	,NULL,	'995678556')
insert into Cliente values(1008,	'Antônio do Valle',	'R. Sete de Setembro',	1894,	NULL)



CREATE TABLE Cliente(

cod INT not null unique,
nome VARCHAR(100) NOT NULL,
logradouro VARCHAR(100),
numero INT,
telefone CHAR(9),
PRIMARY KEY (cod)
)


CREATE TABLE Emprestimo(

cod_cli INT NOT NULL,
cod_livro INT NOT NULL,
dt DATE NOT NULL,
PRIMARY KEY (cod_cli,cod_livro),
FOREIGN KEY (cod_cli) REFERENCES Cliente(cod),
FOREIGN KEY (cod_livro) REFERENCES Livros(cod)
)


CREATE TABLE Livros (

cod INT not null,
cod_autor INT NOT NULL,
cod_corredor INT NOT NULL,
nome VARCHAR(100) NOT NULL,
pag INT NOT NULL,
idioma VARCHAR(30) NOT NULL
PRIMARY KEY(cod),
FOREIGN KEY (cod_autor) REFERENCES Autor(cod),
FOREIGN KEY (cod_corredor) REFERENCES Corredor(cod)

)


CREATE TABLE Corredor(

cod INT not null unique,
tipo VARCHAR(30) NOT NULL,
PRIMARY KEY (cod)
)

CREATE TABLE Autor(

cod INT not null unique,
nome VARCHAR(100) NOT NULL,
pais VARCHAR(30) NOT NULL,
biografia VARCHAR(100) NOT NULL,
PRIMARY KEY (cod)

)

select c.nome, concat(DAY(e.dt),'/',MONTH(e.dt),'/',YEAR(e.dt)) as Data from Cliente c, Emprestimo e
where c.cod = e.cod_cli

select
CASE when (len(a.nome) > 25)
then SUBSTRING(a.nome,1,13)
else
a.nome
END as Nome,
COUNT(distinct l.nome) as Qnt_livros  from Autor a,Livros l where l.cod_autor = a.cod
group by a.nome

select a.nome,a.pais,l.pag from Autor a,Livros l where l.cod_autor = a.cod 
and l.pag in (select max(pag) from Livros)

select c.nome+ ' ' + c.logradouro from Emprestimo e,Cliente c where c.cod = e.cod_cli

select distinct
CASE when (c.logradouro is null and c.numero is null and c.telefone is not null) then
(c.nome + ' ' + c.telefone)
when (c.telefone is null and c.logradouro is not null and c.numero is not null) then
(c.nome + ' ' + c.logradouro + ' ' + cast(c.numero as varchar))
when (c.telefone is not null and c.logradouro is not null and c.numero is not null) then
(c.nome + ' ' + c.telefone+ ' ' + c.logradouro + ' ' + c.telefone + cast(c.numero as varchar))
end as enderço_telefone_logradouro_numero_telefone
from Cliente c left outer join Emprestimo e ON c.cod = e.cod_cli where e.cod_cli is null


select COUNT(*) from Livros l left outer join Emprestimo e on l.cod = e.cod_livro where e.cod_livro is null


select a.nome,c.tipo,COUNT(l.cod) As qnt from Livros l, Autor a, Corredor c 
where l.cod_autor = A.cod and c.cod = l.cod_corredor
group by a.nome, c.tipo
order by qnt

select c.nome, c.nome, DATEDIFF(dd, e.dt, '2012-05-18') as dias_empestados,
    case when (DATEDIFF(dd, e.dt, '2012-05-18') > 4)
        then
            'Atrasado'
        else
            'No Prazo'
    end as statusEmprestimo
from Emprestimo e, Livros l, Cliente c
where e.cod_cli = c.cod and e.cod_livro = l.cod


select c.cod,c.tipo, COUNT(l.cod) as qtn_livros from Corredor c,Livros l where l.cod_corredor = c.cod
group by c.cod,c.tipo


select 
a.nome
from Autor a,Livros l where l.cod_autor = a.cod 
group by a.nome
having COUNT(l.cod) >= 2

select a.nome,count(l.cod) from Autor a,Livros l where l.cod_autor = a.cod and count(l.cod) > 2
group by a.nome


select c.nome,l.nome from Emprestimo e, Livros l, Cliente c
where e.cod_cli = c.cod and e.cod_livro = l.cod
and e.cod_cli in (select cod_cli from Emprestimo where DATEDIFF(dd, e.dt, '2012-05-18') >= 7)
